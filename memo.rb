require 'csv'

class MemoApp
  def initialize
    @memos = load_memos_from_csv
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
    print "メモを入力してください: "
    memo = gets.chomp     #ユーザーからの入力を変数memoに代入
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
    display_memos     #メモの一覧を表示させて
    print "編集するメモの番号を入力してください: "     
    index = gets.chomp.to_i - 1     #入力された番号から−1された数字が配列内の

    if index >= 0 && index < @memos.length     #①indexが0以上で、メモの数以内の時
      print "新しいメモを入力してください: "     
      new_memo = gets.chomp     #新規で入力されたメモを変数new_memoに代入し
      @memos[index] = new_memo     #指定されたindexの要素を更新する
      puts "メモを編集しました。"
    else     #①の条件を満たさないとき以下の処理となる
      puts "無効な番号です。再度入力してください。"
    end
  end

  def save_memos_to_csv
  CSV.open('test.csv', 'w') do |csv|     #CSVファイルを書き込みモードを開き
      @memos.each { |memo| csv << [memo] }     #@memosの要素を繰り返し処理しCSVに書き込んでいく
    end
  end

  def load_memos_from_csv     #CSVファイルからメモを読み込んで配列に格納する
    memos = []     #空の配列 memos を作成して、この配列にCSVファイルから読み込んだメモが格納される
    if File.exist?('test.csv')     #test.csvが存在した場合
      CSV.foreach('test.csv') { |row| memos << row[0] }     #各行の最初（row0）を行ごとに取得して
    end
    memos
  end
end

# インスタンスの生成とメモアプリの開始
MemoApp.new

