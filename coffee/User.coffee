class User
    constructor: (@id, @session) ->
    setId: (id) =>
        @id = id
    getId: =>
        @id
    setSession: (session) =>
        @session = session
    getSession: =>
        @session
