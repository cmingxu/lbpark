$local_pic_dir = "/Users/cmingxu/Downloads/5-KUAIPAN/快盘/我收到的共享文件/arieso@foxmail.com/萝卜头"
$local_pic_dir = "/Users/cmingxu/Downloads/2-LB/4-FULL_VERSION_LB_DATA/20150209导入数据"
$local_pic_dir = "/home/ubuntu/att"

task :import_attachments => :environment do
  Park.where("id>8775").find_each do |park|
    Dir.glob($local_pic_dir + "/**/#{park.pic_num}.*") do |pic_file|
      puts "#{park.id} #{park.pic_num} #{pic_file}"

      park_pic = park.park_pics.build
      park_pic.park_pic = File.open(pic_file)
      park.save
    end
  end
end
