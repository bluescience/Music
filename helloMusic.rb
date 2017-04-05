3.times do
  play :D
  play :A
  sleep 0.25
  4.times do
    play :C
    play :F
    sleep 0.1
    sample :bd_808
    sleep 0.1
  end
end
