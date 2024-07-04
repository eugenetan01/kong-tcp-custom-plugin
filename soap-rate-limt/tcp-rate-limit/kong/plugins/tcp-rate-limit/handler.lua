local ngx = ngx
local kong = kong

local plugin = {
    PRIORITY = 1000,
    VERSION = "0.1",
}

local global_counter = 0
local last_period = nil

function plugin:init_worker()
    kong.log.debug("saying hi from the 'init_worker' handler")
end


function plugin:preread(plugin_conf)
    kong.log.debug("saying hi from the 'preread' handler")
    local current_time = ngx.time()
    local current_period = math.floor(current_time / 60) * 60  -- Current period (60-second window)

    -- Retrieve the counter and timestamp from the shared dictionary
    local counter, err = global_counter

    -- Initialize counter and period if not present
    if not counter or last_period ~= current_period then
        global_counter = 0
        last_period = current_period
        counter = 0
    end

    -- Increment the counter
    counter = counter + 1
    global_counter = counter

    -- Check the counter
    if counter > 5 then
        -- Rate limit exceeded
        kong.log.err("ERROR: Exceeded rate limit. Exiting Process.")
        return ngx.exit(429)
    end
end


function plugin:log(plugin_conf)
    kong.log.debug("saying hi from the 'log' handler")
end

return plugin
