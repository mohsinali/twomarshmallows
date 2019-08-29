App.agent_assignment = App.cable.subscriptions.create "AgentAssignmentChannel",
  connected: ->    

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("#lnk-assign-" + data["contact_id"]).addClass("d-none");
    $("#btn-agent-name-" + data["contact_id"]).removeClass("d-none").html(data["agent_name"]);

