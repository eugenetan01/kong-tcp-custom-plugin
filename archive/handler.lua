-- handler.lua
local TCPCounterHandler = {
    PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.1",
}

function TCPCounterHandler:new()
    TCPCounterHandler.super.new(self, "my-tcp-packet-counter")
end

function TCPCounterHandler:access(conf)
    TCPCounterHandler.super.access(self)

    -- Read the request body
    local body, err = kong.request.get_raw_body()
    if err then
        kong.log.err("Error reading request body: ", err)
        return kong.response.exit(500, { message = "Internal Server Error" })
    end

    -- Count the number of packets (assuming packets are delimited by "\n")
    local packet_count = 0
    for _ in string.gmatch(body, "[^\n]+") do
        packet_count = packet_count + 1
    end

    -- Log the packet count
    kong.log.info("Number of packets in TCP request payload: ", packet_count)

    -- Send the packet count to the FastAPI endpoint
    local httpc = http.new()
    local res, err = httpc:request_uri("http://logapp:2011/packets", {
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["X-Packet-Count"] = packet_count
        },
        body = string.format('{"packet_count": %d}', packet_count)
    })

    if not res then
        kong.log.err("Failed to send packet count to FastAPI: ", err)
        return kong.response.exit(500, { message = "Internal Server Error" })
    end
end

-- return TCPCounterHandler

-- kong.log.err("saying hi from log phase")

-- kong.request.

-- Get the number of bytes sent and received
-- local bytes_sent = kong.nginx.var.bytes_sent
-- local bytes_received = kong.nginx.var.bytes_received

-- kong.log.err(string.format("Bytes sent: %d, Bytes received: %d", bytes_sent, bytes_received))
