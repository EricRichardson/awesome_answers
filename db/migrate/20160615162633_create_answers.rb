class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      # This will generate an integer field named 'question_id'
      # The index true option will add an index on the question_id field. We are likely to use it in queries
      # The foriegn_key :true option will add a foreign key constraint on the question_id field in the questions table
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
