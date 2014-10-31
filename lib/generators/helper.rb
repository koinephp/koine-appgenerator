module Koine
  module Generators
    module Helper

      def template_dir(directory, opitons = {})
        base = self.class.templates_path + "/"
        Dir[base + "#{directory}/**/*"].each do |file|
          unless File.directory?(file)
            file = file.gsub(base, "")
            source      = file.gsub(/\.erb$/, '')
            destination = file
            template(source, destination, options)
          end
        end
      end

    end
  end
end
