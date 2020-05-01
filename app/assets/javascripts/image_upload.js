$(function(){
  $(document).on('turbolinks:load', ()=> {
    const buildFileField = (index)=> {
      const html = `<div data-index="${index}" class="js-file_group">
                      <div class="js-image-zone"></div>
                      <input class="js-file" type="file"
                      name="item[images_attributes][${index}][image]"
                      id="item_images_attributes_${index}_image"><br>
                      <div class="js-remove">削除↑</div>
                    </div>`;
      return html;
    }
  
    let fileIndex = [1,2,3,4,5,6,7,8,9,10];

    $('#image-box').on('change', '.js-file', function(e) {
      $(this).next().next().addClass('js-remove-true');
      // 仮置き
      const imgName = $(this).val();
      const imgNameHTML = `<p>${imgName}</p>`;
      $($(this).prev()).append(imgNameHTML);
      $(this).css('display', 'none');
      if ($('.js-file').length < 10) {
        $('#image-box').append(buildFileField(fileIndex[0]));
        fileIndex.shift();
        fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
      }
    });
  
    $('#image-box').on('click', '.js-remove', function() {
      $(this).parent().remove();
      // 9と10の境を繋ぐ
      console.log($('.js-remove-true').length == 9);
      if ($('.js-remove-true').length == 9) {
        $('#image-box').append(buildFileField(fileIndex[0]));
        fileIndex.shift();
        fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
      }
    });
  });
})