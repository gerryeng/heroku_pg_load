require 'yaml'
require 'uri'

class HerokuPgLoader

	def start
		begin
			get_app_name
			get_database_details

			load_database


		rescue Exception => e
			puts "Error: #{e}"
		ensure
			dump_file.close
			File.delete(dump_file)
		end
	end

	private

	def get_url_contents(url_string)
		require 'open-uri'
		open(url_string).read
	end

	def load_database
		run_command "heroku pgbackups:capture --app #{@heroku_app_name} --expire"

		heroku_backup_url = run_command "heroku pgbackups:url --app #{@heroku_app_name}"

		puts "Dumping to: #{dump_file.path}"

		dump_file.write get_url_contents(heroku_backup_url)

		run_command "echo \"DROP DATABASE #{@db_name}; CREATE DATABASE #{@db_name};\" | psql -U #{@db_username} -d postgres"

		run_command "pg_restore --verbose --clean --no-acl --no-owner -h 127.0.0.1 -U #{@db_username} -d #{@db_name} #{dump_file.path}"
	end

	def dump_file
		if @dump_file.nil?
			path = "#{working_dir}/latest.dump"
			@dump_file = File.open(path, 'w')
		end
		@dump_file
	end

	def run_command(command)
		puts "[Running] #{command}"
		output = `#{command}`; result = $?.success?
		raise "Error" unless result

		output
	end

	def get_database_details

		guess_database_from_rails_config

		@db_name = prompt "Local Database Name:\n (WARNING: THIS DATABASE WILL BE ERASED)",
		@db_name,
		"Database name not entered"

		@db_username = prompt "Database Username:",
		@db_username,
		"Database username not entered"

		@db_password = prompt "Database Password:",
		@db_password,
		"Database Password not entered"
	end

	def guess_database_from_rails_config
		rails_db_config_file = "#{working_dir}/config/database.yml"

		if File.exist? rails_db_config_file

			# Read database.yml
			db_config = YAML.load_file(rails_db_config_file)

			dev_config = db_config["development"]
			if dev_config["adapter"] == "postgresql"
				@db_name = dev_config["database"]
				@db_username = dev_config["username"]
				@db_password = dev_config["password"]
			end
		end
	end

	def working_dir
		Dir.getwd
	end

	def prompt(message, current_value, error_message)
		puts "#{message} [#{current_value}]"
		print ">"
		input = gets.chomp
		current_value = input if input != ""
		raise error_message if current_value.nil?

		current_value
	end

	def get_app_name
		guess_app_name

		@heroku_app_name = prompt "Heroku App Name:",
		@heroku_app_name,
		"No Heroku App Name entered"
	end

	def guess_app_name

		if File.exist?("#{working_dir}/.git")
			git_remote = `git remote -v | grep heroku`

			/git@heroku.com:(\w*).git/.match(git_remote)
			@heroku_app_name = $1

			if @heroku_app_name
				puts "Heroku App Detected: #{@heroku_app_name}"
			end
		end
	end

end