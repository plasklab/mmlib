### モデルをお借りした文献
- 文献[1] : Linden, A.: On the Verication of Programs on Relaxed Memory Models, PhD Thesis, Universite de Liege (2013).
- 文献[2] : 産業技術総合研究所システム検証研究センター：モデル検査上級編－実践のための三つの技法－，株式会社近代科学社(2010).


### ディレクトリ構成

|ディレクトリ|中身|
|:--|:--|
|mutex|[1]に記載されているメモリモデルを考慮したモデル|
|mutex/forLib|mmlibを使用したモデル|
|mutex/origin|通常のPromelaで記述したモデル|
|textbook|[2]のモデル|
|textbook/forLib|mmlibを使用したモデル|
|textbook/origin|モデル検査の教科書に記載されているモデル|

### 各ディレクトリ内のファイル
TSOで検査する場合は，"/* mfence needed */"と記述している位置にフェンス命令を挿入してください．  
PSOで検査する場合は，TSOでフェンス命令を挿入する位置に加えて，"/* sfence needed */"と記述している位置にもフェンス命令を挿入してください．

#### mutex/forLib

|ファイル|内容|
|:--|:--|
|burns_liveness.pml|Burnsのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|burns_safety.pml|Burnsのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|dekker_liveness.pml|Dekkerのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|dekker_safety.pml|Dekkerのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|dijkstra_liveness.pml|Dijkstraのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|dijkstra_safety.pml|Dijkstraのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|lamportFast_liveness.pml|Lamport Fastのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|lamportFast_safety.pml|Lamport Fastのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|lamportBakery_liveness.pml|Lamport Bakeryのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|lamportBakery_safety.pml|Lamport Bakeryのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|peterson_liveness.pml|Petersonのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|peterson_safety.pml|Petersonのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|peterson_ast_liveness.pml|PSOでも活性が満たされるように文献[1]を参考にフェンス命令を挿入する，Petersonのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|peterson_ast_safety.pml| PSOでも活性が満たされるように文献[1]を参考にフェンス命令を挿入する，Petersonのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|szymanski_liveness.pml|Szymanskiのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|szymanski_safety.pml|Szymanskiのアルゴリズムによる相互排除モデルの安全性を検査するモデル．


#### mutex/origin

|ファイル|内容|
|:--|:--|
|burns_liveness.pml|Burnsのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|burns_safety.pml|Burnsのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|dekker_liveness.pml|Dekkerのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|dekker_safety.pml|Dekkerのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|dijkstra_liveness.pml|Dijkstraのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|dijkstra_safety.pml|Dijkstraのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|lamportFast_liveness.pml|Lamport Fastのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|lamportFast_safety.pml|Lamport Fastのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|lamportBakery_liveness.pml|Lamport Bakeryのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|lamportBakery_safety.pml|Lamport Bakeryのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|peterson_liveness.pml|Petersonのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|peterson_safety.pml|Petersonのアルゴリズムによる相互排除モデルの安全性を検査するモデル．
|szymanski_liveness.pml|Szymanskiのアルゴリズムによる相互排除モデルの活性を検査するモデル．
|szymanski_safety.pml|Szymanskiのアルゴリズムによる相互排除モデルの安全性を検査するモデル．


#### textbook/forLib

|ファイル|内容|
|:--|:--|
|3.5.2.pml|3.5.2節のモデル．|
|prac_2.2.pml|練習2.2のモデル．|
|ques_2.1_liveness.pml|問題2.1のモデルの活性を検査するモデル．|
|ques_2.1_safety.pml|問題2.1のモデルの安全性を検査するモデル．|
|ques3.1.pml|問題3.1のモデル．|
|ques3.3.pml|問題3.3のモデル．|
|ques3.7_liveness.pml|問題3.7のモデルの活性を検査するモデル．|
|ques3.7_safety.pml|問題3.7のモデルの活性を検査するモデル．|


#### textbookorigin

|ファイル|内容|
|:--|:--|
|3.5.2.pml|3.5.2節のモデル．|
|prac_2.2.pml|練習2.2のモデル．|
|ques_2.1_liveness.pml|問題2.1のモデルの活性を検査するモデル．|
|ques_2.1_safety.pml|問題2.1のモデルの安全性を検査するモデル．|
|ques3.1.pml|問題3.1のモデル．|
|ques3.3.pml|問題3.3のモデル．|
|ques3.7_liveness.pml|問題3.7のモデルの活性を検査するモデル．|
|ques3.7_safety.pml|問題3.7のモデルの活性を検査するモデル．|
