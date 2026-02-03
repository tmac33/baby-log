# Product Spec

## Target Users
- Parents of infants (0–12 months)

## Core Use Cases
1. Quick feed log: amount (ml) + time
2. Quick diaper log: wet/dirty + time
3. Voice log: "宝宝喝了100ml" / "刚换尿布" / "喂奶100毫升"

## Data Model (Draft)
- FeedingEntry: id, time, amountML, note
- DiaperEntry: id, time, type (wet/dirty/mixed), note

## Voice Parsing (Draft)
- Extract amount: regex (\d+\s*(ml|毫升|cc))
- Detect intent: feed/diaper keywords
- Default time: now
