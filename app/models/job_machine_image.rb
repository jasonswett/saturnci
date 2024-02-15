class JobMachineImage
  POLLING_INTERVAL_IN_SECONDS = 5
  SNAPSHOT_NAME = "my_snapshot"

  def initialize(droplet_id)
    @droplet_id = droplet_id
    @client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
  end

  def create_snapshot
    shutdown

    log "creating snapshot"
    @client.droplet_actions.snapshot(
      droplet_id: @droplet_id,
      name: SNAPSHOT_NAME
    )
  end

  private

  def shutdown
    log "shutting down"
    @client.droplet_actions.shutdown(droplet_id: @droplet_id)
    poll_for_off_status
    log "status is off"
  end

  def poll_for_off_status
    loop do
      sleep(POLLING_INTERVAL_IN_SECONDS)
      log "waiting for 'off' status"
      droplet = @client.droplets.find(id: @droplet_id)
      break if droplet.status == 'off'
    end
  end

  def log(message)
    Rails.logger.info "Droplet #{@droplet_id}: #{message}"
  end
end
