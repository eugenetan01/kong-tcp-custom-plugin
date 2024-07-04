local typedefs = require "kong.db.schema.typedefs"
local Schema = require "kong.db.schema"
local constants = require "kong.constants"


local stream_protocols = {}
for protocol, subsystem in pairs(constants.PROTOCOLS_WITH_SUBSYSTEM) do
    if subsystem == "stream" then
        stream_protocols[#stream_protocols + 1] = protocol
    end
end
table.sort(stream_protocols)

typedefs.protocols_stream = Schema.define {
    type = "set",
    required = true,
    default = stream_protocols,
    elements = { type = "string", one_of = stream_protocols },
}

-- Grab pluginname from module name
local plugin_name = ({ ... })[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
    name = plugin_name,
    fields = {
        -- the 'fields' array is the top-level entry with fields defined by Kong
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_stream },
        {
            config = {
                type = "record",
                fields = {
                }
            }
        },
    },
}

return schema
