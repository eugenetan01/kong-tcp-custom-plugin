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
    kong.log("preread")

    if not ngx.ctx.ratelimit then
        ngx.ctx.ratelimit = 0
    end

    -- Get the TCP socket
    local tcpsock, err = ngx.req.socket()
    if not tcpsock then
        kong.log.err("failed to get the request socket: ", err)
        return
    end

    tcpsock:settimeout(0)
    local limiter = ngx.ctx.ratelimit

    local data, err, partial = tcpsock:receive(5)
    if not data and err ~= "timeout" then
        kong.log.err("failed to receive data: ", err)
        return
    end

    ngx.ctx.ratelimit = limiter + (data and #data or #partial)
    kong.log.err("Current rate limit count: ", ngx.ctx.ratelimit)

    if ngx.ctx.ratelimit >= 5 then
        kong.log.err("rate limit exceeded")
        return kong.response.exit(429)
    end
end


function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
