# baby-log

iOS app for baby feeding & diaper log with voice + manual input.

## MVP Features
- Log feeding (amount + time)
- Log diaper changes (wet/dirty + time)
- Voice input parsing (e.g., "宝宝喝了100ml")
- Timeline view and daily summary

## Structure
- `src/` SwiftUI app source (to be generated on macOS with Xcode)
- `docs/` product specs and architecture

## Next Steps
1. Create Xcode SwiftUI project on macOS
2. Add voice input pipeline (AVSpeech/ASR)
3. Implement local storage (CoreData/SQLite)
