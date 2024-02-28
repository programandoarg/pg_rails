require 'English'

module PgEngine
  class PdfPreviewGenerator
    def open_tempfile
      FileUtils.mkdir_p('tmp')
      tempfile = Tempfile.open('PgEnginePdfPreview-', 'tmp')

      begin
        yield tempfile
      ensure
        tempfile.close
        tempfile.unlink
      end
    end

    def capture(*argv, to:)
      to.binmode

      open_tempfile do |err|
        IO.popen(argv, err:) { |out| IO.copy_stream(out, to) }
        err.rewind

        unless $CHILD_STATUS.success?
          raise "#{argv.first} failed (status #{$CHILD_STATUS.exitstatus}): #{err.read.to_s.chomp}"
        end
      end

      to.rewind
    end

    def draw(*argv)
      open_tempfile do |file|
        capture(*argv, to: file)

        yield file
      end
    end

    def run(pdf_string)
      open_tempfile do |tmp_pdf_file|
        tmp_pdf_file.binmode
        tmp_pdf_file.write pdf_string
        tmp_pdf_file.close
        draw 'pdftoppm', '-singlefile', '-cropbox', '-r', '72', '-png', tmp_pdf_file.path do |file|
          return file.read
        end
      end
    end
  end
end
