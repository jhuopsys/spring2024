#! /usr/bin/env ruby

require 'csv'

FRONT_STUFF = <<'EOF1'
---
layout: default
title: "Schedule"
category: "schedule"
---

This page lists topics, readings, and has links to lecture slides.
It also lists assignment due dates.  Items <span class="tentative">in
gray italic</span> are tentative.

This schedule could change!  Changes
to the schedule will be announced in class and/or on
[Courselore](https://courselore.org/).

Readings are from [Operating Systems: Three Easy Pieces](https://pages.cs.wisc.edu/~remzi/OSTEP/).
This is an open-source textbook, and you can use the links below to access the chapters
directly.

**Important**: do the reading *before*
you come to class.

The links to slides are provided for reference.  In general, there is no
guarantee that they will be posted before class, or that their content
will not change.

Acknowledgment: The course schedule and structure is based on
[Ryan Huang](https://web.eecs.umich.edu/~ryanph/)'s [version of the course](https://www.cs.jhu.edu/~huang/cs318/fall22/).

Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Topic/Slides | Reading | Assignment
------------------ | ------------ | ------- | ----------
EOF1

print FRONT_STUFF

first = true
CSV.foreach('schedule.csv') do |row|
  if first
    first = false
  else
    # Date,Topic,Slides,"Example Code",Reading,Assignment
    while row.length < 6
      row.push('')
    end

    row = row.map {|x| x.nil? ? '' : x}

    date, topic, slides, example_code, reading, assignment = row

    #puts date

    print date

    if slides != ''
      print " | [#{topic}](#{slides})"
    else
      print " | #{topic}"
    end

    if example_code != ''
      # Special case: if the first character is "[", assume it's
      # custom Markdown code that should be included verbatim
      if example_code.start_with?('[')
        print ", #{example_code}"
      else
        print ", [#{example_code} (example code)](lectures/#{example_code})"
      end
    end

    print " | #{reading}"

    puts " | #{assignment}"
  end
end
