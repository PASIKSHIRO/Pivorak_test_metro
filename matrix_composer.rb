# frozen_string_literal: true

class MatrixComposer
  def initialize(raw_data:, value_key:, points:)
    @data          = raw_data
    @value_key     = value_key
    @points        = points
    @result_matrix = {}
  end

  def compose
    initialize_matrix!
    fill_matrix!

    result_matrix
  end

  private

  attr_reader :data, :value_key, :points, :result_matrix

  def initialize_matrix!
    @result_matrix = points.map { |station| [station, {}] }.to_h
  end

  def fill_matrix!
    data.each { |connection| build_connection(connection) }
  end

  def build_connection(connection)
    from  = connection['start'].to_s
    to    = connection['end'].to_s
    value = connection[value_key]

    result_matrix[from][to] = value
    result_matrix[to][from] = value
  end
end
