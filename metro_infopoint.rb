# frozen_string_literal: true

require 'psych'
require_relative 'matrix_composer'
require_relative 'optimal_way_calculator'

class MetroInfopoint
  DATA_KEY   = 'timing'
  POINTS_KEY = 'stations'

  PRICE_KEY = 'price'
  TIME_KEY  = 'time'

  def initialize(path_to_timing_file:, path_to_lines_file:)
    @data     = read_file_data(path_to_timing_file, DATA_KEY)
    @stations = read_file_data(path_to_lines_file, POINTS_KEY).keys
  end

  def calculate(from_station:, to_station:)
    {
      price: calculate_price(from_station: from_station, to_station: to_station),
      time:  calculate_time(from_station: from_station, to_station: to_station)
    }
  end

  def calculate_price(from_station:, to_station:)
    matrix = MatrixComposer.new(raw_data: data, value_key: PRICE_KEY, points: stations).compose
    OptimalWayCalculator.new(matrix: matrix, from: from_station, to: to_station).calculate
  end

  def calculate_time(from_station:, to_station:)
    matrix = MatrixComposer.new(raw_data: data, value_key: TIME_KEY, points: stations).compose
    OptimalWayCalculator.new(matrix: matrix, from: from_station, to: to_station).calculate
  end

  private

  attr_reader :data, :stations

  def read_file_data(file_path, key)
    file = File.open(file_path)

    Psych.load(file.read)[key]
  end
end
