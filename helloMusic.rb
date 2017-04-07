5.times do
  sample :elec_blip2
  sleep 0.5
end
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
sleep 0.15
play :A1
sleep 0.5
play :A2
sleep 0.5
play :A3
sleep 0.5
play :A4
sleep 0.5
play :A5
sleep 0.5
play :A
sleep 0.5
6.times do
  play :E
  sleep 0.1
end
sleep 0.7
play :B5
play :C5
sleep 0.2
play :B
play :C

