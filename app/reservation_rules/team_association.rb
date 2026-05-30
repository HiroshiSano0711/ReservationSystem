module ReservationRules
  class TeamAssociation
    def initialize(team:, objects:)
      @team = team
      @objects = objects.flatten.compact
    end

    # TODO: 例外を発生させないといけない系の業務エラーなので、他のルールとは種類が違う。
    # 設計をちょっと考えたい。どちらかというと入力の前提条件に該当する。
    def validate!
      @objects.each { |obj| raise if @team != obj.team }
    end
  end
end
