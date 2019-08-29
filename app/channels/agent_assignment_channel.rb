class AgentAssignmentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "agent_assignment_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
