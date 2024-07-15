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
    local tcpsock, err = ngx.req.socket()
    tcpsock:settimeout(0)
    local received = 0

    local upstream_sock = ngx.socket.tcp()
    kong.log.err("DESTINATION IP: ", ngx.ctx.balancer_data.host)
    kong.log.err("DESTINATION PORT: ", ngx.ctx.balancer_data.port)
    local ok, err = upstream_sock:connect(ngx.ctx.balancer_data.host, ngx.ctx.balancer_data.port)
    if not ok then
        kong.log.err("failed to connect to upstream: ", err)
        return
    end

    local line, err, partial = tcpsock:receive(1)
    while received < 5 do
      kong.log.err("successfully read a line: ", #line)
      line, err, partial = tcpsock:receive(1)
      received = received + #line
      local bytes_sent, err = upstream_sock:send(line)
      if not bytes_sent then
        kong.log.err("failed to send data to upstream: ", err)
        break
      end
    end

    upstream_sock:close()
end


function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
