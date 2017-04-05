# DUBSTEP
# Combines ideas from my other gists
current_bpm = 140.0
use_bpm current_bpm

# WOBBLE BASS
define :wob do
  use_synth :dsaw
  lowcut = note(:E1) # ~ 40Hz
  highcut = note(:G8) # ~ 3000Hz
  
  note = [40, 41, 28, 28, 28, 27, 25, 35].choose
  
  duration = 2.0
  bpm_scale = (60 / current_bpm).to_f
  distort = 0.2
  
  # scale the note length based on current tempo
  slide_duration = duration * bpm_scale
  
  # Distortion helps give crunch
  with_fx :distortion, distort: distort do
    
    # rlpf means "Resonant low pass filter"
    with_fx :rlpf, cutoff: lowcut, cutoff_slide: slide_duration do |c|
      play note, attack: 0, sustain: duration, release: 0
      
      # 6/4 rhythms
      wobble_time = [1, 6, 6, 2, 1, 2, 4, 8, 3, 3, 16].choose
      c.ctl cutoff_slide: ((duration / wobble_time.to_f) / 2.0)
      
      # Playing with the cutoff gives us the wobble!
      # low cutoff    -> high cutoff        -> low cutoff
      # few harmonics -> loads of harmonics -> few harmonics
      # wwwwwww -> oooooooo -> wwwwwwww
      #
      # N.B.
      # * The note is always the same length *
      # * the wobble time just specifies how many *
      # * 'wow's we fit in that space *
      wobble_time.times do
        c.ctl cutoff: highcut
        sleep ((duration / wobble_time.to_f) / 2.0)
        c.ctl cutoff: lowcut
        sleep ((duration / wobble_time.to_f) / 2.0)
      end
    end
  end
end

in_thread(name: :wob) do
  with_fx :reverb, mix: 0.1 do
    loop do
      wob
    end
  end
end

# FUNKY DRUMS
ghost = -> { rrand(0.1, 0.2) }
normal = -> { rrand(0.5, 0.6) }
accent = -> { rrand(0.8, 0.9) }

swing_time = 0.05
puts swing_time

define :play_kick do
  sample :elec_hollow_kick
  play :A1
end

in_thread(name: :beat) do
  loop do
    # Two ways of modelling beats - with 0s and 1s OR with indexes
    [1, 0, 0, 0, 0, 0, 1, 0].each.with_index(1) do |kick, index|
      play_kick if kick == 1
      
      if [1,3,4,5,7,8].include? index
        # Rand here can be really nice
        sample :drum_cymbal_closed, amp: ((index % 2) == 0 ? ghost.call : normal.call ) if rand < 0.8
      end
      
      with_fx :reverb, mix: 0.5 do
        # Always have snare on 2 and 4
        if index == 5
          sample :drum_snare_hard, amp: normal.call
        end
      end
      
      # And sometimes on the and of 4
      if (index % 2) == 0
        sample :drum_snare_soft, amp: ghost.call if rand < 0.05
      end
      
      
      if(index % 2) == 0
        # offbeats need to be slightly late for swing
        sleep (0.5 - swing_time)
      else
        sleep (0.5 + swing_time)
      end
    end
  end
end

# SAMPLES
in_thread(name: :beat) do
  loop do
    with_fx :echo, rate: 1 do
      with_fx :rlpf, cutoff: rrand(80, 120) do
        sample [:ambi_haunted_hum, :ambi_piano].choose, rate: [0.25, 0.5, 1, 2].choose if rand > 0.1
        sleep 4
      end
    end
  end
end