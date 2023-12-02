require 'csv'

class MemoApp
  def initialize(file_path)
    @memos = load_memos_from_csv
    @file_path = file_path
    start_app
  end

  #初期画面　メニュー選択
  def start_app
    loop do
      puts "\nメモアプリ"
      puts "1. 新規のメモを追加する"
      puts "2. メモの一覧"
      puts "3. 既存のメモを編集する"
      puts "4. メモを保存する"
      print "選択: "
      choice = gets.chomp.to_i    #選択された数字を入力された数字を数値オブジェクトとして受け取り変数choiceに代入

      case choice     #選択されてた数字に合わせて以下のメソッドに移る
      when 1
        add_memo
      when 2
        display_memos
      when 3
        edit_memo
      when 4
        save_memos_to_csv
        break
      else
        puts "1.2.3.4のいずれかのボタンを押してください"
      end
    end
  end

  def add_memo
    print "メモを入力してください (複数行入力の場合は最後にCtrl-Dを入力): "
    memo = $stdin.read.chomp     #複数行をまとめて読み取る
    @memos << memo     #@memoの配列にmemoの内容を追加する
  end

  def display_memos
    if @memos.empty?     #まだ要素がない時の処理
      puts "メモはありません。"
    else     #要素がある時の処理
      puts "メモ一覧:"
      @memos.each_with_index do |memo, index|     #配列内にある要素を繰り返し処理で取り出す
        puts "#{index + 1}. #{memo}"     #配列の番号（index）に１を足した数がメモの番号となる
      end
    end
  end

  def edit_memo
    display_memos     #メモ一覧を表示して
    print "編集するメモの番号を入力してください: "     
    index = gets.chomp.to_i - 1     #入力された番号から−1された数字が配列内の

    if index >= 0 && index < @memos.length      #①indexが0以上で、メモの数以内の時
      print "新しいメモを入力してください: "
      new_memo = $stdin.read.chomp     #新規で入力されたメモを複数行入力可能な状態で変数new_memoに代入し
      @memos[index] = new_memo     #指定されたindexの要素を更新する
      puts "メモを編集しました。"
    else
      puts "無効な番号です。再度入力してください。"
    end
  end

  def save_memos_to_csv
  CSV.open(@file_path, 'w') do |csv|     #CSVファイルを書き込みモードを開き
      @memos.each { |memo| csv << [memo] }     #@memosの要素を繰り返し処理しCSVに書き込んでいく
    end
  end

  def load_memos_from_csv
    memos = []
    if @file_path && File.exist?(@file_path)     #@file_pathが指定されており、ファイルが存在していれば
      CSV.foreach(@file_path) { |row| memos << row[0] }     #foreach を使用してCSVファイルを行ごとに読み込み、各行の最初の要素（row[0]）を memos 配列に追加します。
    end
    memos     #memos 配列を返す
  end
end


puts "保存するファイル名を入力して下さい:"
file_path = gets.chomp + ".csv"
MemoApp.new(file_path)



