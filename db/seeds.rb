# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a User


require "csv"

def check_if_created(object, f)
  object.valid?
  name = nil
  if object.respond_to?('name') 
    name = object.name
  elsif object.respond_to?('at') 
    name = object.at.to_s
  else
    name = ""
  end
  if object.errors.empty?
    yield if block_given?
  else
    f.puts "#{object.class}(#{name}) : #{object.errors.full_messages.inspect}"
  end
  puts  object.errors.empty? ? "created #{object.class}: #{name}" : "#{name}: #{object.errors.full_messages.inspect}"
  object.save 
end

if ENV['ELASTICSEARCH_URL']
	puts ENV['ELASTICSEARCH_URL']
	@client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
else
	@client = ::Elasticsearch::Client.new
end

puts "Creating ElasticSearch index..."
@client.indices.delete({index: DEFAULT_USERNAME}) if @client.indices.exists({ index: DEFAULT_USERNAME})
@client.indices.create({index: DEFAULT_USERNAME})
puts "...Successfully created elasticsearch index"


Sensit::User.destroy_all
Doorkeeper::Application.destroy_all
Doorkeeper::AccessGrant.destroy_all
Sensit::Topic.destroy_all
Sensit::Topic::Field.destroy_all

DEFAULT_USERNAME = "solink"
DEFAULT_PASSWORD = "ClhgCk22"
DEFAULT_EMAIL = "cwaddington@solinkcorp.com"
DEFAULT_APP_NAME = "demo"
DEFAULT_APP_REDIRECT_URI = "http://localhost:3000/oauth2/callback"

path_to_csv = File.dirname(__FILE__) + "/data/ILP_20131009_1801.csv"

File.open('seed_errors.txt', 'w') do |f|

	puts "Creating user: #{DEFAULT_USERNAME}..."
	@user = Sensit::User.new(name: DEFAULT_USERNAME, email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
	check_if_created(@user, f)

	puts "Creating Default OAuth application"
	@application = Doorkeeper::Application.new(name: DEFAULT_APP_NAME, redirect_uri: DEFAULT_APP_REDIRECT_URI)
	check_if_created(@application, f)

	puts "Creating OAuth Access Grant for super user"
	@access_grant = Doorkeeper::AccessGrant.new(application: @application, resource_owner_id:@user.id, expires_in: 6000, redirect_uri: DEFAULT_APP_REDIRECT_URI, scopes: "read_any_data write_any_data delete_any_data read_any_percolations write_any_percolations delete_any_percolations read_any_reports write_any_reports delete_any_reports read_any_subscriptions write_any_subscriptions delete_any_subscriptions")
	check_if_created(@access_grant, f)

	puts "Creating topic"
	@topic = Sensit::Topic.new(name: "ILP", description: "ILP transactions", user: @user, application: @application)
	check_if_created(@topic, f)

	fields = []

	# DATATYPES = %w[string integer boolean decimal datetime timezone image_file video_file file]
	product_field = Sensit::Topic::Field.new(name: "Product", key: "Product", datatype: "string", topic: @topic)
	check_if_created(product_field, f)
	fields << product_field

	customer_type_field = Sensit::Topic::Field.new(name: "Current Customer Type", key: "Current_Cust_Type", datatype: "string", topic: @topic)
	check_if_created(customer_type_field, f)
	fields << customer_type_field

	customer_company_field = Sensit::Topic::Field.new(name: "Company", key: "Company", datatype: "string", topic: @topic)
	check_if_created(customer_company_field, f)
	fields << customer_company_field

	store_field = Sensit::Topic::Field.new(name: "Store", key: "Store_Num", datatype: "string", topic: @topic)
	check_if_created(store_field, f)
	fields << store_field

	customer_name_field = Sensit::Topic::Field.new(name: "Customer", key: "Cust_Name", datatype: "string", topic: @topic)
	check_if_created(customer_name_field, f)
	fields << customer_name_field

	customer_ssn_field = Sensit::Topic::Field.new(name: "Cust. SSN", key: "Cust_SSN", datatype: "integer", topic: @topic)
	check_if_created(customer_ssn_field, f)
	fields << customer_ssn_field

	customer_address_field = Sensit::Topic::Field.new(name: "Address", key: "Cust_Address", datatype: "string", topic: @topic)
	check_if_created(customer_address_field, f)
	fields << customer_address_field

	customer_city_field = Sensit::Topic::Field.new(name: "City", key: "City", datatype: "string", topic: @topic)
	check_if_created(customer_city_field, f)
	fields << customer_city_field

	customer_drivers_license_field = Sensit::Topic::Field.new(name: "Drivers License", key: "Drivers_Lic_Num", datatype: "string", topic: @topic)
	check_if_created(customer_drivers_license_field, f)
	fields << customer_drivers_license_field

	aba_number_field = Sensit::Topic::Field.new(name: "ABA Number", key: "Cust_ABA_Number", datatype: "integer", topic: @topic)
	check_if_created(aba_number_field, f)
	fields << aba_number_field

	bank_account_field = Sensit::Topic::Field.new(name: "Bank Account", key: "Cust_Bank_Acct", datatype: "integer", topic: @topic)
	check_if_created(bank_account_field, f)
	fields << bank_account_field

	customer_number_field = Sensit::Topic::Field.new(name: "Customer Number", key: "Customer_Number", datatype: "integer", topic: @topic)
	check_if_created(customer_number_field, f)
	fields << customer_number_field

	loan_number_field = Sensit::Topic::Field.new(name: "Loan Number", key: "Loan_Number", datatype: "integer", topic: @topic)
	check_if_created(loan_number_field, f)
	fields << loan_number_field

	loan_date_field = Sensit::Topic::Field.new(name: "Loan Date", key: "Loan_Date", datatype: "datetime", topic: @topic)
	check_if_created(loan_date_field, f)
	fields << loan_date_field

	loan_amount_field = Sensit::Topic::Field.new(name: "Loan Amount", key: "Loan_Amt", datatype: "decimal", topic: @topic)
	check_if_created(loan_amount_field, f)
	fields << loan_amount_field

	total_paid_field = Sensit::Topic::Field.new(name: "Total Paid", key: "Total_Paid", datatype: "decimal", topic: @topic)
	check_if_created(total_paid_field, f)
	fields << total_paid_field

	total_due_field = Sensit::Topic::Field.new(name: "Total Due", key: "Total_Due", datatype: "decimal", topic: @topic)
	check_if_created(total_due_field, f)
	fields << total_due_field

	loan_end_date_field = Sensit::Topic::Field.new(name: "Loan End Date", key: "Loan_End_Date", datatype: "datetime", topic: @topic)
	check_if_created(loan_end_date_field, f)
	fields << loan_end_date_field

	loan_term_field = Sensit::Topic::Field.new(name: "Loan Term", key: "Loan_Term", datatype: "string", topic: @topic)
	check_if_created(loan_term_field, f)
	fields << loan_term_field

	is_crash_kit_field = Sensit::Topic::Field.new(name: "Is CrashKit", key: "Is_CrashKit", datatype: "string", topic: @topic)
	check_if_created(is_crash_kit_field, f)
	fields << is_crash_kit_field

	trans_number_field = Sensit::Topic::Field.new(name: "Trans  Number", key: "Transaction_ID_Number", datatype: "integer", topic: @topic)
	check_if_created(trans_number_field, f)
	fields << trans_number_field

	trans_type_field = Sensit::Topic::Field.new(name: "Trans Type", key: "Transaction_Type", datatype: "string", topic: @topic)
	check_if_created(trans_type_field, f)
	fields << trans_type_field

	trans_date_field = Sensit::Topic::Field.new(name: "Trans Date", key: "Tran_Date", datatype: "datetime", topic: @topic)
	check_if_created(trans_date_field, f)

	void_id_field = Sensit::Topic::Field.new(name: "Void ID", key: "Void_ID", datatype: "string", topic: @topic)
	check_if_created(void_id_field, f)
	fields << void_id_field

	customer_check_type_field = Sensit::Topic::Field.new(name: "Customer Check Type", key: "Cust_Check_Type", datatype: "string", topic: @topic)
	check_if_created(customer_check_type_field, f)
	fields << customer_check_type_field

	drawer_code_field = Sensit::Topic::Field.new(name: "Drawer Code", key: "Drawer_Code", datatype: "integer", topic: @topic)
	check_if_created(drawer_code_field, f)
	fields << drawer_code_field

	created_by_field = Sensit::Topic::Field.new(name: "Created By", key: "Created_By", datatype: "string", topic: @topic)
	check_if_created(created_by_field, f)
	fields << created_by_field

	check_status_id_field = Sensit::Topic::Field.new(name: "Check Status ID", key: "CheckStatus_ID", datatype: "string", topic: @topic)
	check_if_created(check_status_id_field, f)
	fields << check_status_id_field

	loan_status_id_field = Sensit::Topic::Field.new(name: "Loan Status ID", key: "Loan_Status_ID", datatype: "string", topic: @topic)
	check_if_created(loan_status_id_field, f)
	fields << loan_status_id_field

	loan_max_field = Sensit::Topic::Field.new(name: "Loan Max", key: "LoanMax", datatype: "string", topic: @topic)
	check_if_created(loan_max_field, f)
	fields << loan_max_field

	current_employer_1_field = Sensit::Topic::Field.new(name: "Current Employer 1", key: "Current_EmpName1", datatype: "string", topic: @topic)
	check_if_created(current_employer_1_field, f)
	fields << current_employer_1_field

	current_employer_2_field = Sensit::Topic::Field.new(name: "Current Employer 2", key: "Current_EmpName2", datatype: "string", topic: @topic)
	check_if_created(current_employer_2_field, f)
	fields << current_employer_2_field

	current_employer_3_field = Sensit::Topic::Field.new(name: "Current Employer 3", key: "Current_EmpName3", datatype: "string", topic: @topic)
	check_if_created(current_employer_3_field, f)
	fields << current_employer_3_field

	employee_field = Sensit::Topic::Field.new(name: "Employee", key: "Employee_Name", datatype: "string", topic: @topic)
	check_if_created(employee_field, f)
	fields << employee_field

	netspend_date_field = Sensit::Topic::Field.new(name: "NetSpend Date", key: "NetSpend_Date", datatype: "datetime", topic: @topic)
	check_if_created(netspend_date_field, f)
	fields << netspend_date_field

	netspend_amount_field = Sensit::Topic::Field.new(name: "NetSpend Amount", key: "NetSpend_Amount", datatype: "decimal", topic: @topic)
	check_if_created(netspend_amount_field, f)
	fields << netspend_amount_field

	# open the csv
	found_fields = false
	field_map = {}
	at_index = nil
	CSV.foreach(path_to_csv) do |row|
		unless found_fields
			field_map = fields.inject({}) do |map, field|
				idx = row.index(field.key)
				unless idx.nil?
					map.merge!(idx => field)
				else
					map
				end
			end
			at_index = row.index(trans_date_field.key)
			# first row is the mapping to the fields
			found_fields = true
		else
			# create the hash of parameters to import
			# :at, :tz, :values
			at = row[at_index]
			values = {}
			field_map.each_pair do |idx, field|
				val = row[idx]
				unless val.nil? || val == "NULL"
					values.merge!(field.key => val)
				end
			end

			feed = Sensit::Topic::Feed.new({index: @user.name, type: @topic.to_param, at: at, values: values})
			check_if_created(feed, f)
		end
	end

end