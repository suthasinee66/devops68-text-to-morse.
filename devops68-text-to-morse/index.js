const express = require('express');
const app = express();

const morseMap = {
  'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
  'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
  'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
  'Y': '-.--', 'Z': '--..', '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-',
  '5': '.....', '6': '-....', '7': '--...', '8': '---..', '9': '----.'
};

app.get('/convert', (req, res) => {
  const { text } = req.query;
  if (!text) return res.status(400).json({ error: 'Missing text parameter' });
  
  const morse = text.toUpperCase().split('').map(char => morseMap[char] || ' ').join(' ');
  res.json({ input: text, morse });
});

app.listen(3030, () => console.log('Text to Morse Code API on port 3030'));
