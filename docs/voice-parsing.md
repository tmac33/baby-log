# Voice Parsing Rules (v1)

## Goals
- Convert short voice commands into structured log entries
- Support Mandarin + simple English tokens
- Handle feeding and diaper events

## Example Utterances
- "宝宝喝了100ml"
- "喂奶100毫升"
- "喝奶120"
- "刚换尿布"
- "换了尿布，湿的"
- "dirty diaper"
- "wet diaper"

## Intent Detection
### Feeding
Keywords:
- 喝奶 / 喂奶 / 牛奶 / 奶量 / 毫升 / ml / cc

### Diaper
Keywords:
- 换尿布 / 尿布 / 拉臭 / 大便 / 小便 / wet / dirty

## Parsing Rules
### Amount
Regex (first pass):
- `(\d+)\s*(ml|毫升|cc)`
- If only number exists and feeding intent is detected, assume ml

### Diaper Type
- If contains: "湿" / "小便" / "wet" => wet
- If contains: "臭" / "大便" / "dirty" => dirty
- If both present => mixed

### Time
- Default: now
- Future: support "刚才" (now - 5m), "半小时前" (now - 30m)

## Output Schema
```json
{
  "type": "feeding" | "diaper",
  "time": "ISO-8601",
  "amountML": 100,
  "diaperType": "wet|dirty|mixed",
  "note": "raw transcript"
}
```

## Confirmation UI
- Always show parsed summary and allow quick edit before saving
