local ngx = ngx
local kong = kong

local plugin = {
    PRIORITY = 1000,
    VERSION = "0.1",
}


function plugin:init_worker()
    kong.log.debug("saying hi from the 'init_worker' handler")
end

function plugin:preread(plugin_conf)
    counter = 0
    kong.log.err("saying hi from the 'preread' handler")
    local tcpsock, err = ngx.req.socket()
    tcpsock:settimeout(5000)
    local data = ""
    local chunk, err, partial
    local last_reset = ngx.now()
    local max_limit = 2

    repeat
        chunk, err, partial = tcpsock:receive(1) -- Read in larger chunks
        kong.log.err("Current counter: ", counter)

        if counter >= max_limit then
            kong.log.err("Rate Limit Exceeded")
            break
        end

        if chunk and #chunk > 0 then
            data = data .. chunk
            kong.log.err("Received full data: ", chunk, " | Chunk size: ", #chunk)
            counter = counter + #chunk
        elseif partial and #partial > 0 then
            data = data .. partial
            kong.log.err("Received partial data: ", partial, " | Chunk size: ", #partial)
            counter = counter + #partial
        end

        if err then
            kong.log.err("Error received: ", err)
            if err == "closed" or err == "timeout" then
                break
            else
                kong.log.err("Failed to read TCP message: ", err)
                break
            end
        end
    until (not chunk or #chunk == 0) and (not partial or #partial == 0)
  
    -- Log the raw TCP message
    kong.log.err("TCP Message: ", counter)
    local limited_data = data:sub(1, max_limit)
    kong.log.err(#limited_data)

    -- Send message upstream
    local upstream_sock = ngx.socket.tcp()
    kong.log.err("WHERE ARE U GOING:", ngx.ctx.balancer_data.host)
    kong.log.err("WHERE ARE U GOING:", ngx.ctx.balancer_data.port)
    local ok, err = upstream_sock:connect(ngx.ctx.balancer_data.host, ngx.ctx.balancer_data.port)
    kong.log.err("preparing to send tcp now")
    upstream_sock:settimeout(10000)
    if not ok then
        kong.log.err("failed to connect to upstream: ", err)
        return
    end
    local bytes, err = upstream_sock:send(limited_data)
    if not bytes then
        kong.log.err("failed to send message upstream: ", err)
        return
    end

    if err then
        kong.log.err(err)
    end 

    kong.log.err("sent tcp now")

end


function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
