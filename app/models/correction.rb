# frozen_string_literal: true
# 由於本系統為動態計算，當計算公式因故有所調整時，
# 會與既有會計紀錄（且會計端已無法修改）產生誤差，
# 為讓系統報表與會計紀錄維持一致，可透過此 model 做手動校正
class Correction < ApplicationRecord
  belongs_to :statement
end
