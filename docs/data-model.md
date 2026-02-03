# Data Model (v1)

## Entities
### FeedingEntry
- id: UUID
- time: Date
- amountML: Int
- note: String?

### DiaperEntry
- id: UUID
- time: Date
- type: enum { wet, dirty, mixed }
- note: String?

## Storage
- v1: local JSON or SQLite
- v2: CoreData
- v3: iCloud sync

## Derived Metrics
- Daily total feeding amount
- Average interval between feeds
- Diaper count per day
