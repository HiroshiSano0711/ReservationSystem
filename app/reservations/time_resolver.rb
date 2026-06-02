module Reservations
  module TimeResolver
    # 時間の扱いは慎重に行うべきで前もってしっかり考えておく、という設計思想です。
    # 時間に関する仕様の変更コスト、バグった場合、事故などになった場合のリスクが高いため。
    #
    # 時間の保存はUTCで統一、アプリケーションで扱う場合にそれぞれのタイムゾーンに変換するルール
    # フォーマットは以下の正規表現で統一（ISO8601が広すぎるので）
    #   年月日、T、時分秒までは必須。
    #   末尾のオフセット（Z または +09:00 / -0500 等）は任意
    #
    #   使用できるフォーマット
    #     例： "2026-01-01T10:00:00"
    #     例： "2026-01-01T10:00:00Z"
    #     例： "2026-01-01T10:00:00+0900"
    #     例： "2026-01-01T10:00:00-0400"
    # なぜこのように変換するか？は、入力はオフセットがない場合（CSV、日時だけ選択するUIなど）もあるためです。
    # グローバルスタンダード、国際対応といった理由はどちらかというと薄いです。
    # オフセットがない場合はそのユーザーのタイムゾーンで変換する。
    VALID_TIME_FORMAT = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|[+-]\d{2}:?\d{2})?\z/

    def self.parse_with_user_time_zone(time_zone: nil, time_str:)
      if time_str.blank? || !time_str.match?(VALID_TIME_FORMAT)
        raise ArgumentError, "Invalid time format: #{time_str.inspect}"
      end

      time_zone ||= "Tokyo"
      ActiveSupport::TimeZone[time_zone].parse(time_str)
    end

    def self.parse_str_utc_format(time_zone: nil, time_str:)
      parsed_time = parse_with_user_time_zone(time_zone: time_zone, time_str: time_str)
      parsed_time.utc.iso8601
    end
  end
end
