# Lab 7: Verifying My Custom Component Using System Console and /dev/mem

**Note**: After answering these questions, I've come to realize that I've programmed my base_period to instead act as a base_frequency. Unless this ends up being a major issue down the line I think I'll just stick with my code and re-label base_period to base_freq wherever it pops up. Let me know though if that is gonna come back to bite me later on.

**Question**: What hex value did you write to base_period (base_freq for me) to have a 0.125 second base period?

**Answer**: To set my base period to 0.125 seconds (clock completes an on-off cycle 8 times a second), I wrote 0x80 to base_freq, which corresponds to a period of 8.0 cycles per second.

**Question**: What hex value did you write to base_period (again base_freq for me) to have a 0.5625 second base period?

**Answer**: To set my base period to 0.5625 seconds (clock completes an on-off cycle roughly 1.78 times a second), I wrote 0x1C to base_freq, which corresponds to a period of 1.75 cycles per second. Since I'm using frequency instead of period, my cycle time is a bit off.