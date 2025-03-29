local BasePlugin = require "kong.plugins.base_plugin"
local pgmoon = require "pgmoon"

local DBValidatorHandler = BasePlugin:extend()

function DBValidatorHandler:new()
  DBValidatorHandler.super.new(self, "db-validator")
end

function DBValidatorHandler:access(conf)
  DBValidatorHandler.super.access(self)

  local pg = pgmoon.new({
    host = conf.db_host,
    port = conf.db_port,
    database = conf.db_name,
    user = conf.db_user,
    password = conf.db_password
  })

  local ok, err = pg:connect()
  if not ok then
    kong.log.err("Failed to connect to database: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  local res, err = pg:query(conf.query)
  if not res then
    kong.log.err("Failed to execute query: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  if #res == 0 then
    return kong.response.exit(403, { message = "Forbidden" })
  end

  -- Clean up
  pg:keepalive()
end

return DBValidatorHandler