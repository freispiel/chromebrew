require 'package'

class Stack < Package
  description 'The Haskell Tool Stack - Stack is a cross-platform program for developing Haskell projects. It is aimed at Haskellers both new and experienced.'
  homepage 'https://docs.haskellstack.org/'
  @_ver = '2.5.1'
  version @_ver
  license 'BSD'
  compatibility 'all'
  source_url "https://github.com/commercialhaskell/stack/releases/download/v#{@_ver}/stack-#{@_ver}-linux-x86_64.tar.gz"
  source_sha256 'c83b6c93d6541c0bce2175085a04062020f4160a86116e20f3b343b562f2d1e8'

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/stack/2.5.1_armv7l/stack-2.5.1-chromeos-armv7l.tpxz',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/stack/2.5.1_armv7l/stack-2.5.1-chromeos-armv7l.tpxz',
    x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/stack/2.5.1_x86_64/stack-2.5.1-chromeos-x86_64.tpxz'
  })
  binary_sha256({
    aarch64: 'c133843b51770fcd93dfa4f8328cccbf06f4523ea9ebc9764d812ff50d527054',
     armv7l: 'c133843b51770fcd93dfa4f8328cccbf06f4523ea9ebc9764d812ff50d527054',
    x86_64: '23722336f49adc7c685e8ca936928b2f3d53fd4f826ce4603062d9bd1f409b2d'
  })

  def self.install
    FileUtils.mkdir_p CREW_DEST_HOME
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/.stack"
    system "install -Dm755 stack #{CREW_DEST_PREFIX}/bin/stack"
    system "echo 'local-bin-path: #{CREW_PREFIX}/bin' > #{CREW_DEST_PREFIX}/.stack/config.yaml"
    system "echo 'local-programs-path: #{CREW_PREFIX}/share/stack' >> #{CREW_DEST_PREFIX}/.stack/config.yaml"
    FileUtils.ln_s "#{CREW_PREFIX}/.stack", "#{CREW_DEST_HOME}/.stack"

    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/etc/bash.d/"
    @env = <<~EOF
      # Haskell stack bash completion
      eval "$(stack --bash-completion-script stack)"
    EOF
    IO.write("#{CREW_DEST_PREFIX}/etc/bash.d/stack", @env)
  end

  def self.remove
    puts
    puts 'To completely uninstall stack, execute the following:'.lightblue
    puts "rm -rf #{CREW_PREFIX}/share/stack".lightblue
    puts 'rm -rf ~/.stack'.lightblue
    puts
  end
end
