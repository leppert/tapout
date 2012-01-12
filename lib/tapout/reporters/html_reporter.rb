require 'tapout/reporters/abstract'

module TapOut::Reporters

  # HTML Test Reporter
  #
  # This reporter is rather simplistic and rough at this point --in needs
  # of some TLC.
  #--
  # TODO: Make this more like a microformat and add timer info.
  #++
  class Html < Abstract

    #
    def start_suite(entry)
      timer_reset

      puts %[<html>]
      puts %[<head>]
      puts %[<title>Test Report</title>]
      puts %[  <style>]
      puts %[    html{ background: #fff; margin: 0; padding: 0; font-family: helvetica; }]
      puts %[    body{ margin: 0; padding: 0;}]
      puts %[    h3{color:#555;}]
      puts %[    #main{ margin: 0 auto; color: #110; width: 600px; ]
      puts %[           border-right: 1px solid #ddd; border-left: 1px solid #ddd; ]
      puts %[           padding: 10px 30px; width: 500px; } ]
      puts %[    .title{ color: gold; font-size: 22px; font-weight: bold; ]
      puts %[            font-family: courier; margin-bottom: -15px;}]
      puts %[    .tally{ font-weight: bold; margin-bottom: 10px; }]
      puts %[    .omit{ color: cyan; }]
      puts %[    .pass{ color: green; }]
      puts %[    .fail{ color: red; }]
      puts %[    .footer{ font-size: 0.7em; color: #666; margin: 20px 0; }]
      puts %[  </style>]
      puts %[</head>]
      puts %[<body>]
      puts %[<div id="main">]
      puts %[<div class="title">R U B Y - T E S T</div>]
      puts %[<h1>Test Report</h1>]
    end

    #
    def start_case(entry)
      body = []

      puts "<h2>"
      puts entry['label']
      puts "</h2>"

      puts body.join("\n")
    end

    #
    def start_test(entry)
      if subtext = entry['subtext']
        if @subtext != subtext
          @subtext = subtext
          puts "<h3>#{subtext}</h3>"
        end
      end
    end

    #
    def pass(entry)
      puts %[<li class="pass">]
      puts "%s %s" % [ "PASS", entry['label'] ]
      puts %[</li>]
    end

    #
    def fail(entry)
      e = entry['exception']

      puts %[<li class="fail">]
      puts "FAIL #{e['message']}"
      puts "<pre>"
      puts clean_backtrace(e['backtrace']).join("\n")
      puts "</pre>"
      puts %[</li>]
      # TODO: Add captured_stdout and _stderr
    end

    #
    def error(entry)
      e = entry['exception']

      puts %[<li class="error">]
      puts "ERROR "
      puts e['message'].to_s
      puts "<pre>"
      puts clean_backtrace(e['backtrace']).join("\n")
      puts "</pre>"
      puts %[</li>]
      # TODO: Add captured_stdout and _stderr
    end

    #
    def todo(entry)
      e = entry['exception']

      puts %[<li class="pending">]
      puts "TODO "
      puts e['message'].to_s
      puts %[</li>]
    end

    #
    def omit(entry)
      e = entry['exception']

      puts %[<li class="omit">]
      puts "OMIT "
      puts e['message'].to_s
      puts %[</li>]
    end

    #
    def finish_suite(entry)
      puts ""
      puts %[<div class="tally">]
      puts tally_message(entry)
      puts %[</div>]
      puts ""
      puts ""
      puts %[<div class="footer">]
      puts %[Generated by <a href="http://rubyworks.github.com/tapout">TAPOUT</a>]
      puts %[on #{Time.now}.]
      puts %[</div>]
      puts ""
      puts %[</div>]
      puts %[</div>]
      puts ""
      puts %[</body>]
      puts %[</html>]
    end

  private

    #
    def timer
      secs  = Time.now - @time
      @time = Time.now
      return "%0.5fs" % [secs.to_s]
    end

    #
    def timer_reset
      @time = Time.now
    end

  end

end
