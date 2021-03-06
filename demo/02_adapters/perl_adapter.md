# TAP Parser

Given a legacy TAP stream:

    1..3
    ok 1 - Example A
    not ok 2 - Example B
      ---
      file:        foo.rb
      line:        45
      description: this is that
      found:       this
      wanted:      that
      raw_test:    assert_equal('that', 'this')
      extensions:
        THAC0:     16
      ...
    ok 3

The PerlAdapter can convert the stream into TAP-Y.

    stream = StringIO.new(@tap)

    adapter = Tapout::PerlAdapter.new(stream)

    entries = adapter.to_a

Once converted, there should five entries --a header and footer, two
passing tests and one failing test.

    entries.size.assert == 5

Or pipe the converted stream directly to another stream.

    stream = StringIO.new(@tap)

    adapter = Tapout::PerlAdapter.new(stream)

    output = ""

    tapy = adapter | output

Given a legacy TAP stream:

    1..5
    # test by equality
    ok 1 - pass-thru 1
    ok 2 - pass-thru 2
    ok 3 - pass-thru 3
    ok 4 - pass-thru 4
    ok 5 - pass-thru 5
    1..5

Let's see if this works.

    stream = StringIO.new(@tap)

    adapter = Tapout::PerlAdapter.new(stream)

    entries = adapter.to_a

Once converted, there should eight entries --a header and footer, one note
and five passing tests.

    entries.size.assert == 8

