// API endpoints configuratie
// Schakel tussen BoltServer en Station Engine backends


export const API = {
  // Radio state
  STATE:          '/api/state',

  // VFO / Tuning
  VFO:            '/api/vfo',
  MODE:           '/api/mode',
  FILTER:         '/api/filter',
  ZOOM:           '/api/zoom',

  // TX
  MOX:            '/api/tx/mox',
  TUNE:           '/api/tx/tun',
  DRIVE:          '/api/tx/drive',
  MIC_GAIN:       '/api/tx/mic-gain',

  // RX
  RX_AF_GAIN:     '/api/rx/af-gain',
  AGC_TOP:        '/api/agc-top',
  ATTEN:          '/api/atten',
  SQUELCH:        '/api/squelch',

  // Verbinding
  CONNECT:        '/api/connect',
  DISCONNECT:     '/api/disconnect',
  DISCOVER:       '/api/radios',

  // Display

  // Freq cal

}