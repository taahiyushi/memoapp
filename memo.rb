require 'csv'

class MemoApp
  def initialize(file_path)
    @file_path = file_path
    @memos = load_memos_from_csv
    start_app
  end

  def start_app
    loop do
      display_menu
      choice = get_user_choice

      case choice
      when 1 then add_memo
      when 2 then display_memos
      when 3 then edit_memo
      when 4 then save_memos_to_csv; break
      else
        puts "1から4の数字を入力してください。"
      end
    end
  end

  def display_menu
    puts "\nメモアプリ"
    puts "1. 新規のメモを追加する"
    puts "2. メモの一覧"
    puts "3. 既存のメモを編集する"
    puts "4. メモを保存して終了する"
    print "選択: "
  end

  def get_user_choice
    gets.chomp.to_i
  end

  def add_memo
    puts "メモを入力してください。複数行の場合は最後に空行を入力してください。"
    memo = read_multiline_input     #以下のread_multiline_inputメソッドでのメモの入力内容を代入している
    @memos << memo unless memo.empty?     #ユーザーが何かしらのテキストを入力している場合、@memosの配列にmemoを追加する。
  end

  def read_multiline_input
    lines = []
    loop do     #行を読み込み続けてる
      line = gets.chomp     #入力されたメモの内容を変数に代入
      break if line.empty?     #lineが空になる（エンターキーが2回連続で押される）まで処理をループする
      lines << line     #ユーザーに入力されたメモがenterごとに配列linesに入る
    end
    lines.join("\n")     #改行で結合する
  end

  def display_memos
    if @memos.empty?
      puts "メモはありません。"
    else
      puts "メモ一覧:"
      @memos.each_with_index { |memo, index| puts "#{index + 1}. #{memo}" }
    end
  end

  def edit_memo
    display_memos
    index = get_memo_index

    if valid_index?(index)     #有効な範囲内であれば
      new_memo = read_multiline_input     #read_multiline_inputを呼び出し乳卯力された内容を変数new_memoに代入する
      @memos[index] = new_memo     #指定のインデックスのmemoにread_multiline_inputで入力された内容を追加する
      puts "メモを編集しました。"
    else
      puts "無効な番号です。再度入力してください。"
    end
  end

  def get_memo_index
    print "編集するメモの番号を入力してください: "
    gets.chomp.to_i - 1     #入力された数字の−1はインデックス番号
  end

  def valid_index?(index)
    index >= 0 && index < @memos.length
  end

  def save_memos_to_csv
    CSV.open(@file_path, 'w', encoding: 'UTF-8', force_quotes: false) do |csv|     
      @memos.each { |memo| csv << [memo] }
    end
    puts "メモを保存しました。アプリを終了します。"
  end  

  def load_memos_from_csv
    memos = []
    if File.exist?(@file_path)
      CSV.foreach(@file_path) { |row| memos << row[0] }
    end
    memos
  end
end

puts "保存するファイル名を入力してください:"
file_path = gets.chomp + ".csv"
MemoApp.new(file_path)
