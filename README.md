# Minimal 32-bit İşletim Sistemi Örneği

Bu depo, GRUB'un önyüklediği ve VGA metin ekranına bir mesaj yazan basit bir 32-bit çekirdeğin nasıl derleneceğini ve ISO kalıbı hâline getirileceğini gösterir. Kod tamamen NASM assembly ile yazılmıştır ve ek bağımlılıklar gerektirmez.

## Klasör Yapısı

- `src/boot.asm`: Multiboot uyumlu giriş noktası ve VGA'ya mesaj yazan çekirdek kodu.
- `src/linker.ld`: Çekirdeğin 1 MB adresine yerleşmesi için kullanılan bağlayıcı betiği.
- `src/grub.cfg`: ISO içerisine kopyalanacak GRUB yapılandırması.
- `scripts/build_iso.sh`: Derlenen çekirdeği GRUB ile ISO olarak paketleyen betik.
- `Makefile`: Çekirdeği derlemek ve ISO üretmek için hedefler içerir.

## Gerekli Araçlar

- `nasm`
- `ld` (GNU Binutils)
- ISO üretimi için ek olarak `grub-mkrescue` ve `xorriso`

Bu örnekte çekirdeğin derlenmesi için yalnızca `nasm` ve `ld` yeterlidir. ISO oluşturmak istediğinizde ise ek araçlara ihtiyaç vardır.

## Derleme

```
make
```

Bu komut `build/kernel.elf` dosyasını üretir. Yeniden derlemek için `make clean` komutunu kullanabilirsiniz.

## ISO Oluşturma

```
make iso
```

Betik eksik bağımlılıkları kontrol eder; `grub-mkrescue` veya `xorriso` sisteminizde yoksa nasıl kurulacaklarına dair bir mesaj gösterir. ISO kalıbı varsayılan olarak `build/os.iso` yoluna yazılır. Farklı bir çıktı yolu vermek için betiği doğrudan çağırabilirsiniz:

```
scripts/build_iso.sh myos.iso
```

## ISO'yu Test Etme

Oluşturulan ISO kalıbını QEMU ile çalıştırabilirsiniz:

```
qemu-system-i386 -cdrom build/os.iso
```

QEMU kurulu değilse sisteminizin paket yöneticisi ile kurabilirsiniz.

## Geliştirme Notları

- Çekirdek kodu tamamen 32-bit modda çalışır.
- VGA metin tamponuna beyaz renkli bir mesaj yazdırır ve ardından işlemciyi durdurur.
- Daha fazla özellik eklemek için `src/boot.asm` dosyasındaki `kmain` fonksiyonunu genişletebilirsiniz.
