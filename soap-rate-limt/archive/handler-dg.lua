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
    tcpsock:settimeout(0)
    --local data = ""

    local upstream_sock = ngx.socket.tcp()
    kong.log.err("DESTINATION IP: ", ngx.ctx.balancer_data.host)
    kong.log.err("DESTINATION PORT: ", ngx.ctx.balancer_data.port)
    local ok, err = upstream_sock:connect(ngx.ctx.balancer_data.host, ngx.ctx.balancer_data.port)
    upstream_sock:settimeout(5000)
    if not ok then
        kong.log.err("failed to connect to upstream: ", err)
        return
    end

    local total_received = 0
    local max_size = 1024 -- Maximum size to send upstream
    local should_send = false

    kong.log.err("preread")

    -- Get the TCP socket
     if not tcpsock then
        kong.log.err("failed to get the request socket: ", err)
        return
    end

    local data, err, partial = tcpsock:receiveany(30)
    if not data and err ~= "timeout" then
        kong.log.err("failed to receive data: ", err)
        return
    end

    kong.log.err("Size of payload: ", #data)
    
    
    --[[ while total_received < max_size do
        kong.log.err("How many times in loop: ", counter)
        local data, err, partial = tcpsock:receive(1) -- Read remaining bytes
        if not data then
            if partial then
                data = partial
            else
                if err ~= "closed" then
                kong.log.err("failed to receive data: ", err)
                end
            end
        end

        kong.log.err("Size of payload: ", #data)
        kong.log.err("payload: ", data)

        total_received = total_received + #data

        if total_received >= max_size then
            kong.log.err("total received: ", total_received)
            kong.log.err("request data exceeded the maximum allowed size of ", max_size, " bytes")
            should_send = true
            --return ngx.exit(429)
            break -- Exit the loop once the limit is exceeded
        end

        
    end ]]


    --local bytes_to_send = total_received
    kong.log.err("preparing to send tcp now")
    local bytes_sent, err = upstream_sock:send(data)
    if not bytes_sent then
        kong.log.error("failed to send data to upstream: ", err)
    end

    if err then
        kong.log.err(err)
    end 
    
    if bytes_sent then
        kong.log.err("sent tcp now")
        --counter = counter + 1
        kong.log.err("sent tcp data: ", data)
        --kong.log.err("Received amount: ", total_received)
        local response_message = ""

        local resp_line, err, partial = upstream_sock:receive("*a")
        if not resp_line then
            if err then
                kong.log.err("NOt getting response obj", err)
            end

            kong.log.err("READ done!!!!!!")
        end
        kong.log.err("read chunk: [", resp_line, "]")
        response_message = response_message .. resp_line
        if partial then
            response_message = response_message .. partial
            kong.log.err("read chunk: [", partial, "]")
        end


        kong.log.err("IM GETTING A RESPONSE!!!!: ", response_message)
        
        upstream_sock:close()
        return ngx.exit(429)
    end

    

--[[     if total_received >= max_size then 
        return ngx.exit(413)
    end ]]

  
    --[[ Log the raw TCP message
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

    kong.log.err("sent tcp now")]]

end


function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
