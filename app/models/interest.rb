class Interest < ApplicationRecord
  has_and_belongs_to_many :recipients
  # has_many :links

  def self.search(q)
    q = BlueSkies::Stemmer.stem(q)
    where("array_to_string(stems, ' ; ', NULL) LIKE ?", "%#{q}%")
  end

  def self.published
    where(published: true)
  end

  def self.first_by_stem(stem)
    where('stems @> ARRAY[?]', stem).limit(1).first
  end

  def self.find_or_create_by_name(name)
    stem = Stemmer.stem(name)
    first_by_stem(stem) || create(stems: [stem], name: name)
  end

  before_save do
    self.stems = [BlueSkies::Stemmer.stem(name)] if stems.empty?
  end

  def stems
    super || []
  end

  def add_stem(stem)
    return if stems.include?(stem)
    update(stems: stems + [stem])
  end

  def merge_from(origin)
    # Merge links
    # origin.links.each { |link| link.add_interest(self) }

    # Merge recipients
    # origin.recipients.each { |recipient| recipient.add_interest(self) }

    # Merge stems
    update(stems: stems | origin.stems)

    origin.delete
  end

  def merge_into(dest)
    dest.merge_from(self)
  end

  def publish!
    update_all(published: true)
  end
end
