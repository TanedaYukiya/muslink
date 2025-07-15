class Tag < ApplicationRecord
  validates :name, presence: true

  # 中間テーブルとの関連付け（削除連動させるのはここだけ）
  has_many :tweet_tag_relations, dependent: :destroy

  # 中間テーブルを介した多対多関連（dependentは書かない）
  has_many :tweets, through: :tweet_tag_relations

  # 他の関係（おそらくRegisterモデル用）も同じく正しく書かれてるか要確認
  has_many :register_tags, dependent: :destroy
  has_many :registers, through: :register_tags
end
