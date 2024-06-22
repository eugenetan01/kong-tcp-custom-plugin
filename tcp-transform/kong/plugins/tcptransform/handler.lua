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
    kong.log.debug("saying hi from the 'preread' handler")
    kong.log.debug("\n")
    kong.log.debug("\n")
    local tcpsock, err = ngx.req.socket()
    tcpsock:settimeout(10000)
    kong.log.debug("WHERE ARE U GOING:", ngx.ctx.balancer_data.host)
    kong.log.debug("WHERE ARE U GOING:", ngx.ctx.balancer_data.port)
    local reader, err, partial = tcpsock:receiveuntil("\r\n")
    local line, err, partial = reader()
    kong.log.debug("Read a line!!!!: ", line)

    -- Open new tcp conn to send upstream
    local upstream_sock = ngx.socket.tcp()
    local ok, err = upstream_sock:connect(ngx.ctx.balancer_data.host, ngx.ctx.balancer_data.port)
    kong.log.debug("preparing to send tcp now")
    upstream_sock:settimeout(10000)
    if not ok then
        ngx.say("failed to connect to upstream: ", err)
        return
    end
    local mod_data = line .. " I am a test app!/END"
    kong.log.debug("sending tcp now")
    local bytes, err = upstream_sock:send(mod_data)
    if not bytes then
        kong.log.err("failed to send message upstream: ", err)
        return
    end
    kong.log.debug("sent tcp now")
    -- receive response and log it out
    local resp_reader, err = upstream_sock:receiveuntil("\r\n")
    if not reader then
        kong.debug.log("FAILLL")
        return
    end
    kong.log.debug("creating conn to receive tcp now")
    -- failing here, but upstream is receiving the message
    local resp_reader = upstream_sock:receiveuntil("!/END")
    --[[local resp_line, err, partial = resp_reader()
    if err then
        kong.log.debug("ERRORRRRR at getting resp:", err)
        if err == "timeout" then
            kong.log.debug("gg timeout:", err)
        end
        end]]
    local response_message = ""
    while true do
        local resp_line, err, partial = resp_reader()
        if not resp_line then
            if err then
                kong.log.err("NOt getting response obj", err)
                break
            end

            kong.log.debug("READ done!!!!!!")
            break
        end
        kong.log.debug("read chunk: [", resp_line, "]")
        response_message = response_message .. resp_line
        if partial then
            response_message = response_message .. partial
            kong.log.debug("read chunk: [", partial, "]")
            break
        end
    end

    kong.log.debug("IM GETTING A RESPONSE!!!!: ", response_message)
    local upstream_ok, err = upstream_sock:close()
    if upstream_ok then
        kong.log.debug("UPSTREAM CONN CLOSED")
    else
        kong.logs.debug("UPSTREAM FAILED TO CLOSE", err)
    end
    -- Send the response back to client
    local client_resp, err = tcpsock:send(response_message)
    if not client_resp then
        kong.log.err("failed to send message upstream: ", err)
        return
    end

    kong.log.debug("CLIENT GET THE RESPONSE NOW: ", client_resp, " ", response_message)

    --[[local downstream_ok, err = tcpsock:close()
    if downstream_ok then
        kong.log.debug("UPSTREAM CONN CLOSED")
    else
        kong.logs.debug("UPSTREAM FAILED TO CLOSE", err)
    end]]
    --[[if not resp_line then
        kong.log.debug("NOt getting response obj")
        end

    kong.log.debug("resp_line: ", resp_line)
    if not resp_line then
        kong.log.debug("failed to read a line: ", err)
        return
        end
    kong.log.debug("RESPONSE!!: ", resp_line)]]
end

function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
