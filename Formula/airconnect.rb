class Airconnect < Formula
  # NB: This is only the upnp binary (for Sonos)
  # there is also a cast binary for Chromecast
  desc "Use AirPlay to stream to UPnP/Sonos & Chromecast devices"
  homepage "https://github.com/philippe44/AirConnect"
  version "0.2.51.1"
  license "https://github.com/philippe44/AirConnect/blob/master/LICENSE"
  #url "https://github.com/philippe44/AirConnect/raw/master/bin/airupnp-osx-multi"
  url "https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-osx-multi"
  sha256 "20814190f7bb05640b6005397f5dc987e4f963f55d7f56e60b41de08e3b79c40"

  def install
     bin.install "airupnp-osx-multi" => "airupnp"
     (prefix/"etc/airupnp.xml").write <<~EOS
      <airupnp>
        <common>
        <enabled>1</enabled>
        </common>
      </airupnp>
    EOS
    # Brew auto symlinks the etc above, but not sure if it'll save on upgrade
    #etc.install "etc/airupnp.xml" => "airupnp.xml"
  end

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>com.aircast.bridge</string>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/airupnp</string>
        <string>-Z</string>
              <string>-x</string>
              <string>#{etc}/airupnp.xml</string>
              <string>-f</string>
              <string>#{var}/log/airupnp.log</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>LaunchOnlyOnce</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system "airupnp", "--help"
  end
end
