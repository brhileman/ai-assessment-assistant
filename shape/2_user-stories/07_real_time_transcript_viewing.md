# User Story: Real-Time Transcript Viewing

**As a** company stakeholder  
**I want** to see what the AI is understanding from my speech in real-time  
**So that** I can verify accuracy and clarify if needed

## Context
Transparency in voice transcription builds trust and allows stakeholders to correct misunderstandings immediately.

## Scenarios

### Happy Path
1. During voice conversation, stakeholder sees live transcript updating
2. Transcript accurately captures stakeholder's words
3. Stakeholder continues conversation naturally
4. Any technical terms or proper nouns are transcribed correctly

### Edge Cases
- Transcription errors: Stakeholder can verbally correct ("Actually, I said...")
- Audio unclear: System shows "[unclear]" in transcript
- Long pauses: System shows appropriate waiting indicators

## Acceptance Criteria
- [ ] Live transcript display with smooth scrolling
- [ ] Clear visual distinction between stakeholder and AI text
- [ ] Timestamps for conversation segments
- [ ] Readable font size and contrast
- [ ] Auto-scroll to keep current conversation visible
- [ ] Professional formatting and layout

## Key Screens
- Voice conversation interface with live transcript panel

## Questions
- [ ] Should we highlight potential transcription uncertainties? No
- [ ] Do we need different transcript views (full vs. summary)? No