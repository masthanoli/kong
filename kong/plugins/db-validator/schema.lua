return {
    no_consumer = true,
    fields = {
      db_host = { type = "string", required = true },
      db_port = { type = "number", default = 5432 },
      db_name = { type = "string", required = true },
      db_user = { type = "string", required = true },
      db_password = { type = "string", required = true },
      query = { type = "string", required = true }
    }
  }