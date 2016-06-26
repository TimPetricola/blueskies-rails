require 'test_helper'

class InterestTest < ActiveSupport::TestCase
  let(:model) { Interest }

  it 'populates stem on save' do
    instance = model.create(name: 'Paragliding')
    assert_equal ['paraglid'], instance.stems
  end

  describe '.search' do
    it 'searches based on stem' do
      paragliding = model.create(name: 'Paragliding')
      skydiving = model.create(name: 'Skydiving')

      assert_equal [skydiving], model.search('Sky').to_a
    end
  end

  describe '.find_or_create_by_name' do
    it { skip 'needs testing' }
  end

  describe '#add_stem' do
    it 'adds stem' do
      base = model.create(name: 'BASE')
      base.add_stem('base jump')

      # Ensure no duplication
      base.add_stem('base jump')

      base.reload
      assert_equal ['base', 'base jump'], base.stems
    end
  end

  describe '#merge_into' do
    let(:to) { model.create(name: 'BASE Jumping', stems: ['base jump']) }
    let(:from) { model.create(name: 'BASE', stems: ['base'])}

    it 'merges stems' do
      from.merge_into(to)
      assert_equal ['base jump', 'base'], to.reload.stems
    end

    it 'deletes record' do
      from.merge_into(to)
      error = assert_raises(ActiveRecord::RecordNotFound) { from.reload }
    end

    it 'migrates links' do
      skip
      link_from = BlueSkies::Models::Link.create(url: 'http://blueskies.io/from')
      link_from.add_interest(from)
      link_to = BlueSkies::Models::Link.create(url: 'http://blueskies.io/to')
      link_to.add_interest(to)

      from.merge_into(to)

      assert_equal [link_to, link_from].to_set, to.links.to_set
      assert_equal 1, link_from.reload.interests.count
      assert_equal to.id, link_from.reload.interests.first.id
    end

    it 'migrates recipients' do
      skip
      recipient_from = BlueSkies::Models::Recipient.create(email: 'from@blueskies.io')
      recipient_from.add_interest(from)
      recipient_to = BlueSkies::Models::Recipient.create(email: 'to@blueskies.io')
      recipient_to.add_interest(to)

      from.merge_into(to)

      assert_equal [recipient_to, recipient_from].to_set, to.recipients.to_set
      assert_equal 1, recipient_from.reload.interests.count
      assert_equal to.id, recipient_from.reload.interests.first.id
    end
  end
end
