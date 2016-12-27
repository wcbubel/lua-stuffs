-- Eliza.lua is a very superficial form of rogerian psychotherapy meant for
-- entertainment and educational purposes. It is based on the original MIT Eliza
-- with text taken from the public domain pascal version.

--------------------------------------------------------------------------------

-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted.

-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
-- SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
-- OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
-- CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

--------------------------------------------------------------------------------

-- Responses is a prioritized list, matching posible keys to possible responses.
RESPONSES = {
  {
    KEY = { "can you" },
    REPLY = {
      "Don't you believe that I can*",
      "Perhaps you would like to be able to*",
      "You want me to be able to*",
    },
  }, {
    KEY = { "can i" },
    REPLY = {
      "Perhaps you don't want to*", 
      "Do you want to be able to*",
    },
  }, {
    KEY = { "you are", "you're" },
    REPLY = {
      "What makes you think I am*",
      "Does it please you to believe I am*",
      "Perhaps you would like to be*",
      "Do you sometimes wish you were*",
    },
  }, {
    KEY = { "i don't" },
    REPLY = {
      "Don't you really*",
      "Why don't you*",
      "Do you wish to be able to*",
      "Does that trouble you?",
    },
  }, {
    KEY = { "i feel" },
    REPLY = {
      "Tell me more about such feelings.",
      "Do you often feel*",
      "Do you enjoy feeling*",
    },
  }, {
    KEY = { "why don't you" },
    REPLY = {
      "Do you really believe I don't*",
      "Perhaps in good time I will@",
      "Do you want me to*",
    },
  }, {
    KEY = { "why can't i" },
    REPLY = {
      "Do you think you should be able to*",
      "Why can't you*",
    },
  }, {
    KEY = { "are you" },
    REPLY = {
      "Why are you interested in whether or not I am*",
      "Would you prefer if I were not*",
      "Perhaps in your fantasies I am*",
    },
  }, {
    KEY = { "i can't" },
    REPLY = {
      "How do you know you can't*",
      "Have you tried?",
      "Perhaps you can now*",
    },
  }, {
    KEY = { "i am", "i'm" },
    REPLY = {
      "Did you come to me because you are*",
      "How long have you been*",
      "Do you believe it is normal to be*",
      "Do you enjoy being*",
      "We were discussing you --not me.",
    },
  }, {
    KEY = { "your" },
    REPLY = {
      "Why are you concerned about my*",
      "What about your own*",
    },
  }, {
    KEY = { "you" },
    REPLY = {
      "We were discussing you, not me.",
      "Oh,*",
      "You're not really talking about me, are you?",
    },
  }, {
    KEY = { "i want" },
    REPLY = {
      "What would it mean to you if you got*",
      "Why do you want*",
      "Suppose you got*",
      "What if you never got*",
      "I sometimes also want@",
    },
  }, {
    KEY = { "what", "how", "who", "where", "when", "why" },
    REPLY = {
      "Why do you ask?",
      "Does that question interest you?",
      "What answer would please you the most?",
      "What do you think?",
      "Are such questions on your mind often?",
      "What is it that you really want to know?",
      "Have you asked anyone else?",
      "Have you asked such questions before?",
      "What else comes to mind when you ask that?",
    },
  }, {
    KEY = { "name" },
    REPLY = {
      "Names don't interest me.",
      "I don't care about names, please go on.",
    },
  }, {
    KEY = { "cause" },
    REPLY = {
      "Is that the real reason?",
      "Don't any other reasons come to mind?",
      "Does that reason explain anything else?",
      "What other reasons might there be?",
    },
  }, {
    KEY = { "sorry" },
    REPLY = {
      "Please don't apologise!",
      "Apologies are not necessary.",
      "What feelings do you have when you apologise?",
      "Don't be so defensive!",
    },
  }, {
    KEY = { "dream" },
    REPLY = {
      "What does that dream suggest to you?",
      "Do you dream often?",
      "What persons appear in your dreams?",
      "Are you disturbed by your dreams?",
    },
  }, {
    KEY = { "computer", "machine" },
    REPLY = {
      "Do computers worry you?",
      "Are you talking about me in particular?",
      "Are you frightened by machines?",
      "Why do you mention computers?",
      "What do you think machines have to do with your problems?",
      "Don't you think computers can help people?",
      "What is it about machines that worries you?",
    },
  }, {
    KEY = { "hello", "hi" },
    REPLY = {
      "How do you do. Please state your problem.",
    }
  }, {
    KEY = { "maybe" },
    REPLY = {
      "You don't seem quite certain.",
      "Why the uncertain tone?",
      "Can't you be more positive?",
      "You aren't sure?",
      "Don't you know?",
    },
  }, {
    KEY = { "no" },
    REPLY = {
      "Are you saying no just to be negative?",
      "You are being a bit negative.",
      "Why not?",
      "Are you sure?",
      "Why no?",
    },
  }, {
    KEY = { "always" },
    REPLY = {
      "Can you think of a specific example?",
      "When?",
      "What are you thinking of?",
      "Really, always?",
    },
  }, {
    KEY = { "think" },
    REPLY = {
      "Do you really think so?",
      "But you are not sure you*",
      "Do you doubt you*",
    },
  }, {
    KEY = { "alike" },
    REPLY = {
      "In what way?",
      "What resemblence do you see?",
      "What does the similarity suggest to you?",
      "What other connections do you see?",
      "Could there really be some connection?",
      "How?",
    },
  }, {
    KEY = { "yes" },
    REPLY = {
      "You seem quite positive.",
      "Are you Sure?",
      "I see.",
      "I understand.",
    },
  }, {
    KEY = { "friend" },
    REPLY = {
      "Why do you bring up the topic of friends?",
      "Do your friends worry you?",
      "Do your friends pick on you?",
      "Are you sure you have any friends?",
      "Do you impose on your friends?",
      "Perhaps your love for friends worries you.",
    },
  }
}

-- Possible responses if no key was matched.
DEFAULT_RESPONSES = {
  "Say, do you have any psychological problems?",
  "What does that suggest to you?",
  "I see.",
  "I'm not sure I understand you fully.",
  "Come, come, elucidate your thoughts.",
  "Can you elaborate on that?",
  "That is quite interesting."
}

-- Possible responses if the user repeats themself.
REPEATING = {
  "Why did you repeat yourself?",
  "Do you expect a different answer by repeating yourself?",
  "Come, come, elucidate your thoughts.",
  "Please don't repeat yourself!"
}

-- Inputs that allow the user to exit without ctrl-c'ing out.
EXITS = {
  "quit", "exit", "bye", "goodbye"
}

-- Mapping of nouns to their conjugates
CONJUGATIONS = {
  ["are"]    = "am",   ["we're"] = "was",    ["you"] = "me",
  ["your"]   = "my",   ["I've"]  = "you've", ["I'm"] = "you're",
  ["me"]     = "you",  ["am"]    = "are",    ["was"] = "we're",
  ["you've"] = "I've", ["i"]     = "you",    ["my"]  = "your",
  ["you're"] = "I'm",
}

-- This is the main function that powers Eliza, matching a keyword found in the
-- user's input and building a response using part of their own input.
function build_response(str)
  for _, candidate in ipairs(RESPONSES) do
    local found, rest = find_keys(candidate.KEY, str)
    if found then
      local reply = random_pick(candidate.REPLY)
      local tail = reply:sub(-1)
      if tail == "*" or tail == "@" then
        reply = reply:sub(1, -2)
          .. " "
          .. conjugate(clean_punctuation(trim(str:sub(rest+1))))
          .. ((tail == "*") and "?" or ".")
      end
      return trim(reply)
    end
  end
  return random_pick(DEFAULT_RESPONSES)
end

-- Removed trailing punctuation and whitespace
function clean_punctuation(str)
  return string.gsub(str, "[?!.,]*$", "")
end

-- replaces nouns/verbs in the string with their conjugates.
function conjugate(str)
  return string.gsub(str, "%S+", CONJUGATIONS)
end

-- Reports if and where in a string the keyword list matches.
function find_keys(list, str)
  for _, key in ipairs(list) do
    local s, e = string.find(str, key) 
    if s then return true, e end
  end
  return false
end

-- If a list's item has a direct equality with a value
function list_contains(list, value)
  for _, v in ipairs(list) do
    if value == v then return true end
  end
  return false
end

-- We go with randomly choosing from a list, rather than stepping through all of
-- eliza's possible responses, just to create some variety from repeated use,
-- accepting that she'll birthday-paradox herself fast within in one session.
function random_pick(list)
  return list[math.random(#list)]
end

-- Zap leading and trailing whitespace.
-- took the least weird option from http://lua-users.org/wiki/StringTrim
function trim(str)
  return string.gsub(string.gsub(str, "^%s+", ""), "%s+$", "")
end

-- io stuff is kept way down here, handles exit and repeat input
function read_and_respond(previous)
  io.write("> ")
  local input = string.lower(io.read('*l'))
  io.write("\n")
  if not list_contains(EXITS, input) then
    if previous == input then
      io.write(random_pick(REPEATING), "\n\n")
    else
      io.write(build_response(input), "\n\n")
    end
    return true, input
  else
    return false
  end
end

function main()
  math.randomseed(os.time())
  io.write("*** WELCOME TO ELIZA, PLEASE TELL HER YOUR PROBLEMS.\n\n")

  local loop, previous = true, nil
  while loop do
    loop, previous = read_and_respond(previous)
  end

  io.write("Goodbye. Have a nice day.\n\n")
end

main(...)

