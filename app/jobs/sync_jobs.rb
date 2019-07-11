module SyncJobs
  class Perform < ApplicationJob
    def perform(sync_id)
      sync = Sync.find(sync_id)
      Forms::Syncs::Perform
        .new(sync: sync)
        .save
        .raise_if_error
    end
  end

  class SetupSync < ApplicationJob
    def perform(sync_id)
      Forms::Syncs::Setup.new(
        sync: Sync.find(sync_id)
      ).save.raise_if_error
    end
  end
end
