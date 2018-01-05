class Units::SiController < ApplicationController
  def index
    query = params[:units]
    conversion = SiConversion.new(query)
    @converted = { 
      unit_name: conversion.converted_units, 
      multiplication_factor: conversion.multiplication_factor
    }
    render :index
  end
end
