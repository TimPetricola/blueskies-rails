class Recipient < ApplicationRecord
  TWO_MINUTES = 60 * 2

  has_and_belongs_to_many :interests
  # one_to_many :digests, on_delete: :cascade

  # serialize_attributes :schedule_yaml, :schedule

  before_create :generate_token, if: proc { token.nil? }

  # def interests_ids_dataset
  #   db
  #     .select(:interest_id___id)
  #     .from(:interests_recipients)
  #     .where(recipient_id: id)
  # end

  # def digested_links_ids_dataset
  #   db
  #     .select(:digests_links__link_id___id)
  #     .from(:digests_links)
  #     .join(:digests, id: :digest_id)
  #     .where(recipient_id: id)
  # end

  # def create_and_send_digest(delivery_time: nil)
  #   digest = DigestBuilder.create(recipient: self)

  #   if digest
  #     digest.save
  #     digest.deliver!(delivery_time: delivery_time)
  #   end

  #   enqueue_next_digest(after: delivery_time)
  # end

  # def update_schedule(week_days:, time:)
  #   unschedule_next_digest

  #   schedule = IceCube::Schedule.new(time) do |s|
  #     s.add_recurrence_rule(IceCube::Rule.weekly(1).day(*week_days))
  #   end

  #   update(schedule: schedule)
  #   enqueue_next_digest
  # end

  # def enqueue_next_digest(after: nil)
  #   return false unless schedule

  #   delivery_time = schedule.next_occurrence(after)

  #   # Build digest earlier to ensure it is sent at the right time
  #   build_digest_at = delivery_time - TWO_MINUTES
  #   job_id = Workers::Digest.perform_at(build_digest_at, id, delivery_time.to_i)

  #   update(next_digest_job_id: job_id)
  # end

  # def self.exists?(attributes)
  #   where(attributes).count > 0
  # end

  def add_interest(interest)
    interests.push(interest) unless interests.include?(interest)
  end

  private

  # def unschedule_next_digest
  #   return unless next_digest_job_id

  #   queue = Sidekiq::ScheduledSet.new
  #   job = queue.first { |job| job.jid == next_digest_job_id }
  #   job.delete if job

  #   update(next_digest_job_id: nil)
  # end

  def generate_token
    self.token = SecureRandom.hex(16)
    generate_token if self.class.exists?(token: token)
  end
end
