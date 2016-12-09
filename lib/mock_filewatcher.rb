require "mock_filewatcher/version"
require 'faker'

class MockFilewatcher
  attr_reader :options, :message

  SUPPORTED_VERSIONS = ["1.0", "2.0"]

  # options:
  #  message_version: version of the filewatcher message
  def initialize(options = {})
    default_options = {message_version: "1.0"}
    options = default_options.merge(options)
    throw "unsupported :message_version" unless SUPPORTED_VERSIONS.include?(options[:message_version])
    @bag_path  = "/bags/#{Faker::Lorem.words(2).join("/")}"
    @file_name = "#{Faker::Lorem.words(2).join}.mov"
    @options = options

  end

  # TODO: This will become smarter to add/remove keys based on @options
  def create_fake_message
    @message = universal_key_values
    add_version_specific_key_value_pairs!
    @message
  end

private

  def add_version_specific_key_value_pairs!
    if @options[:message_version] == "1.0"
      @message[:pathToAsset]         = "#{@bag_path}/#{@file_name}"
      @message[:metadata][:fileName] = File.basename(@file_name, ".*")
      @message[:metadata][:extension] = File.extname(@file_name).gsub('.','')
      @message[:metadata][:processingNotes] = [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample

      # These change type in newer versions
      @message[:metadata][:conditionNotes] = [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample
      @message[:metadata][:otherNotes] = [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample

    elsif @options[:message_version] == "2.0"
      # new keys
      @message[:messageVersion] = "2.0"
      @message[:pathToPreservationMaster] = "#{@bag_path}/PreservationMasters/#{@file_name}"
      @message[:pathToServiceCopy]        = "#{@bag_path}/ServiceCopies/#{@file_name}"
      @message[:metadata][:classmark] = "* #{('A'..'Z').to_a.shuffle[0..4].join} #{('1'..'9').to_a.shuffle[0..2].join}"
      @message[:metadata][:cmsID] = "#{(1...10000).to_a.sample}"
      @message[:metadata][:nonCMSID] = "#{(1...10000).to_a.sample}"
      @message[:metadata][:nonCMSItemID] = "#{(1...10000).to_a.sample}"
      @message[:metadata][:cmsCollectionID]= "#{(1...10000).to_a.sample}"
      @message[:metadata][:bnumber] = "B-#{(1...10000).to_a.sample}"

      # Values have changed since v 1.0
      note_proc = Proc.new{ Faker::Lorem.sentences(rand(2)+1).join(" ") }
      @message[:metadata][:conditionNotes] = [[note_proc.call, note_proc.call], []].sample
      @message[:metadata][:otherNotes] = [[note_proc.call, note_proc.call], []].sample
    end
  end


  # This will send out messages that
  def universal_key_values
    fake_checksum = Digest::MD5.new
    fake_checksum.update rand(2000).to_s

    {:UUID => SecureRandom.uuid,
      :assetFileName => "#{@file_name}",
      :definition    => ["hd", "sd"].sample,
      :isInMMS       => [true, false].sample,
      :width         => (500..1000).to_a.sample,
      :height        => (500..1000).to_a.sample,
      :fileSize          => (1024..200000).to_a.sample,
      :pathToBag     => @bag_path,
      :checksum      => fake_checksum.to_s,
      :metadata      => {
        :title => Faker::Lorem.words(rand(6)+1).join,
        :identifier => "ABVVGTU".split("").shuffle.join,
        :typeOfResource => "moving image",
        :dateCreated => ["05/18/2015","07/20/1999","2/12/98E","06/07/77M",nil,""].sample,
        :division => ["dan_MIA", "dan", "myd", nil, ""].sample,
        :objectIdentifier   => [Faker::Code.ean, Faker::Code.ean, nil].sample,
        :format             => ['Digital Betacam', 'VHS', 'DV', nil].sample,
        :generation         => (1..5).to_a.push(nil).sample,
        :broadcastStandard  => ['NTSC', 'PAL', nil].sample,
        :color              => ['b/w', 'color', nil].sample,
        :fileFormat         => ['MPEG-4', 'MOV', 'OGG', nil].sample,
        :audioCodecName     => ['ALAC', 'API', 'WMAL', 'AAL', nil].sample,
        :videoCodecName     => ['AJA 10-bit 4:2:2 Component YCbCr', nil, "DXA", 'non-ISO MPEG-2.5'].sample,
        :contentNotes     => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :accessNote       => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :duration         => ["00:16:25:23", "01:1#{rand{8}+1}:25:23", "01:16:25:#{rand{9}}#{rand{9}}"].sample,
        :dateCaptured     => Faker::Date.backward(1000).strftime("%-m/%d/%y"),
        :projectIdentifier => "#{Faker::Lorem.words(1).first}.xls",
        :formerClassmark   => "* #{('A'..'Z').to_a.shuffle[0..4].join} #{('1'..'9').to_a.shuffle[0..2].join}"
        }
     }
  end
end
