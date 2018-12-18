require 'ostruct'

# TODO: やるべきことはコレだと思うんだけどGolangで書いてないのでとりあえずあとでペラっと書き直す

class Prison
  attr_accessor :already
  def initialize(i)
    @name = i
    @already = false
    @state = 0
    @count = 0
  end

  def leader?
    @name == 0
  end

  def entry(room)
    if leader?
      entry_leader(room)
    else
      entry_follower(room)
    end
  end

  def entry_leader(room)
    if @count == 0
      room.left = false
      room.right = false
      @count += 1
      return false
    end

    if room.left && room.right
      @count += 1
    end

    room.left = false
    room.right = false

    @count == 100
  end

  def entry_follower(room)
    # 00のときだけ操作
    return false if room.left
    return false if room.right

    # 状態2になってるならもう何も行動しない
    return false if @state == 2

    # 00なので状態に合わせて操作
    if @state == 0
      room.left = false
      room.right = true
      @state = 1
      return false
    end

    if @state == 1
      room.left = true
      room.right = true
      @state = 2
      return false
    end

    return false
  end
end

all_ok = true
1000.times do
  ps = []
  100.times do |i|
    prison = Prison.new i
    ps.push prison
  end

  # 部屋(ビット列)をランダムな初期状態で作る
  room = OpenStruct.new(
    left: (rand(2) == 0),
    right: (rand(2) == 0),
  )

  count = 0
  loop do
    i = rand(100)
    selected = ps[ i ]
    selected.already = true # 部屋に入ったことは記録しておく
    break if selected.entry(room)
  end

  # 全部入ったのか調べる
  all_ok &&= ps.all? { |prison| prison.already }
  # だめなのが見つかったら即座に終了
  break unless all_ok
end
puts all_ok
